import random
from util import *

class Rect:
	TL = 0
	TR = 1
	BL = 2
	BR = 3
	def __init__(self, x, y, w, h):
		self.x = x
		self.y = y
		self.w = w
		self.h = h

	def area(self): 
		return self.w * self.h

	def split(self): 
		return [	Rect(self.x, self.y, self.w / 2, self.h / 2), 
					Rect(self.x + self.w / 2, self.y, self.w / 2, self.h / 2), 
					Rect(self.x, self.y + self.h / 2, self.w / 2, self.h / 2), 
					Rect(self.x + self.w / 2, self.y + self.h / 2, self.w / 2, self.h / 2) ]

	def quad(self, p): 
		return (p.x >= self.x + self.w / 2) + (p.y >= self.y + self.h / 2) * 2

	def sample(self):
		return Point(self.x + self.w * random.random(), self.y + self.h * random.random())

	def __str__(self):
		return "(" +  "{:.1f}".format(self.x) + ", " + "{:.1f}".format(self.y) + ", " + "{:.1f}".format(self.w) + ", " + "{:.1f}".format(self.h) + ")"

	def __repr__(self): 
		return self.__str__()

class Node: 
	def __init__(self): 
		x=5

class Edge:
	def __init__(self, l, r): 
		self.l = l
		self.r = r
	def __str__(self):
		return "{" +  str(self.l) + " <--> " + str(self.r) + "}"
	def __repr__(self): 
		return self.__str__()

class Tree: 
	def __init__(self, r):
		self.V = [r]
		self.E = []
	def add(self, n, p):
		self.V += [n]
		self.E += [Edge(p,n)]

class Point(Node, Vector2): 
	def __init__(self, x, y): 
		self.x = x
		self.y = y
	def __str__(self):
		return "(" +  "{:.1f}".format(self.x) + ", " + "{:.1f}".format(self.y) + ")"
	def __repr__(self): 
		return self.__str__()

class QuadNode(Node): 
	def __init__(self, rect): 
		self.quads = None
		self.rect = rect
		self.points = []
		self.samples = 0

	def getQuad(self, p):
		quad = self.rect.quad(p)
		return self.quads[quad]

	def addPoint(self, p, limit): 
		if self.points and self.rect.area() > limit: 
			self.split(limit)
		if self.quads: 
			self.getQuad(p).addPoint(p, limit)
		self.points += [p]

	def getQuads(self, p):
		if self.quads: 
			return self.getQuad(p).getQuads(p) + [self]
		else: return [self]

	def split(self, limit):
		self.quads = [QuadNode(q) for q in self.rect.split()]
		quad = self.rect.quad(self.points[0])
		self.quads[quad].addPoint(self.points[0], limit)

	def distance(self, l, r): 
		return (l.x-r.x)**2 + (l.y-r.y)**2

	def remove(self, p): 
		self.points.remove(p)

	def __str__(self):
		return str(self.rect)
	def __repr__(self): 
		return self.__str__()

	def samplePoint(self, limit, collision):
		sample, closest, quads = None, None, None
		if self.rect.area() < limit or not self.points: 
			s = self.rect.sample()
			if not collision(s):
				sample, closest, quads = s, None, [self]
		else: 
			if not self.quads and self.points: 
				self.split(limit)
			small = min(quad.samples for quad in self.quads)
			mins = list(idx for (idx, quad) in enumerate(self.quads) if quad.samples == small)
			quad = self.quads[random.choice(mins)]
			sample, closest, quads = quad.samplePoint(limit, collision)
			if sample:
				quads += [self]
				if not closest: 
					val, closest = min((self.distance(sample, p), p) for p in self.points)
					if collision(sample, closest): 
						sample, closest, quads = None, None, None
		self.samples += 1
		return sample, closest, quads

class QuadTree(Tree): 
	def __init__(self, w, h, limit, obstacles, start, goal): 
		self.root = QuadNode(Rect(0, 0, w, h))
		self.limit = limit
		self.obstacles = obstacles
		self.addPoint(start)
		self.start = start
		self.goal = goal

	def addPoint(self, p):
		self.root.addPoint(p, self.limit)

	def getQuads(self, p): 
		return self.root.getQuads(p)

	def collision(self, p, c=None): 
		if c:
			for obstacle in self.obstacles: 
				if obstacle.raycast(p, c - p, limitedRay = True):
					return True
		else: 
			for obstacle in self.obstacles: 
				if obstacle.collisionCheck(p): 
					return True
		return False

	def samplePoint(self, towardsGoal=False): 
		p, c, quads = self.root.samplePoint(self.limit, lambda p, c=None: self.collision(p, c))
		if p: 
			n = c + (p - c).norm() * 10
			for quad in self.getQuads(n):
				quad.points += [n]
			return n, c
		else: return None, None
